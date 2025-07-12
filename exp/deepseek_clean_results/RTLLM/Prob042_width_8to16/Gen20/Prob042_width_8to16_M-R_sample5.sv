module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State definitions
parameter IDLE = 1'b0;
parameter HAVE_FIRST_BYTE = 1'b1;

reg state, next_state;
reg [7:0] first_byte;

// Sequential state transition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        first_byte <= 8'b0;
    end else begin
        state <= next_state;
        if (valid_in && (state == IDLE))
            first_byte <= data_in;
    end
end

// Combinational next state logic
always @(*) begin
    case (state)
        IDLE: next_state = valid_in ? HAVE_FIRST_BYTE : IDLE;
        HAVE_FIRST_BYTE: next_state = valid_in ? IDLE : HAVE_FIRST_BYTE;
        default: next_state = IDLE;
    endcase
end

// Combinational output logic
always @(*) begin
    valid_out = 1'b0;
    data_out = 16'b0;
    
    if (state == HAVE_FIRST_BYTE && valid_in) begin
        valid_out = 1'b1;
        data_out = {first_byte, data_in};
    end
end

endmodule