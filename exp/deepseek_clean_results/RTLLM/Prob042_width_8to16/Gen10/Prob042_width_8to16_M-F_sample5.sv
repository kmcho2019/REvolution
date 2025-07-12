module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State encoding with explicit 2-bit representation
localparam [1:0] IDLE       = 2'b00;
localparam [1:0] FIRST_BYTE = 2'b01;

reg [1:0] state;
reg [1:0] next_state;
reg [7:0] first_byte;
reg [7:0] next_first_byte;
reg next_valid_out;
reg [15:0] next_data_out;

// Combinational logic for next state and outputs
always @(*) begin
    // Default assignments
    next_state = state;
    next_first_byte = first_byte;
    next_valid_out = 1'b0;
    next_data_out = data_out;
    
    case (state)
        IDLE: begin
            if (valid_in) begin
                next_first_byte = data_in;
                next_state = FIRST_BYTE;
            end
        end
        
        FIRST_BYTE: begin
            if (valid_in) begin
                next_data_out = {first_byte, data_in};
                next_valid_out = 1'b1;
                next_state = IDLE;
            end
        end
    endcase
end

// Sequential logic for state and data registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        first_byte <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        state <= next_state;
        first_byte <= next_first_byte;
        valid_out <= next_valid_out;
        data_out <= next_data_out;
    end
end

endmodule