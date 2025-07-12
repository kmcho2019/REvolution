module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output wire valid_out,
    output reg [15:0] data_out
);

// State definitions
localparam IDLE      = 1'b0;
localparam FIRST_BYTE = 1'b1;

reg state, next_state;
reg [7:0] first_byte;

// Combinational output
assign valid_out = (state == FIRST_BYTE) && valid_in;

// Combinational next-state logic
always @(*) begin
    case (state)
        IDLE: next_state = valid_in ? FIRST_BYTE : IDLE;
        FIRST_BYTE: next_state = valid_in ? IDLE : FIRST_BYTE;
        default: next_state = IDLE;
    endcase
end

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        first_byte <= 8'b0;
        data_out <= 16'b0;
    end else begin
        state <= next_state;
        
        // Store first byte when transitioning to FIRST_BYTE state
        if (state == IDLE && valid_in) begin
            first_byte <= data_in;
        end
        
        // Output concatenated data when receiving second byte
        if (state == FIRST_BYTE && valid_in) begin
            data_out <= {first_byte, data_in};
        end
    end
end

endmodule