module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// State registers
reg [1:0] state;
reg [size-1:0] bit_counter;
reg [2*size-1:0] accumulator;
reg [2*size-1:0] multiplicand;

// State definitions
localparam IDLE = 2'b00;
localparam ADD = 2'b01;
localparam SHIFT = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        bit_counter <= 0;
        accumulator <= 0;
        multiplicand <= 0;
        mul_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                // Initialize when new inputs arrive
                multiplicand <= {{size{1'b0}}, mul_a};
                accumulator <= 0;
                bit_counter <= 0;
                state <= ADD;
            end
            
            ADD: begin
                // Conditional addition based on current bit
                if (mul_b[bit_counter]) begin
                    accumulator <= accumulator + multiplicand;
                end
                state <= SHIFT;
            end
            
            SHIFT: begin
                // Shift multiplicand for next bit position
                multiplicand <= multiplicand << 1;
                bit_counter <= bit_counter + 1;
                
                // Check if all bits processed
                if (bit_counter == size-1) begin
                    state <= IDLE;
                    mul_out <= accumulator;
                end else begin
                    state <= ADD;
                end
            end
        endcase
    end
end

endmodule