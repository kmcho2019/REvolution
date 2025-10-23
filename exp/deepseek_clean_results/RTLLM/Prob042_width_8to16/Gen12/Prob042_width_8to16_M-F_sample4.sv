module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output wire valid_out,
    output reg [15:0] data_out
);

// State encoding
localparam IDLE      = 2'b00;
localparam FIRST_BYTE = 2'b01;
localparam OUTPUT    = 2'b10;

reg [1:0] state, next_state;
reg [7:0] first_byte;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    case (state)
        IDLE: if (valid_in) next_state = FIRST_BYTE;
        FIRST_BYTE: if (valid_in) next_state = OUTPUT;
        OUTPUT: next_state = (valid_in) ? FIRST_BYTE : IDLE;
        default: next_state = IDLE;
    endcase
end

// Data storage logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        first_byte <= 8'b0;
        data_out <= 16'b0;
    end else begin
        case (state)
            IDLE: if (valid_in) first_byte <= data_in;
            FIRST_BYTE: if (valid_in) data_out <= {first_byte, data_in};
            OUTPUT: if (valid_in) first_byte <= data_in;
            default: ; // No action
        endcase
    end
end

// Output assignments
assign valid_out = (state == OUTPUT);

endmodule