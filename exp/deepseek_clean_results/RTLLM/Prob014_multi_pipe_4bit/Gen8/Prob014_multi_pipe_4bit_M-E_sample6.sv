module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline registers
reg [2*size-1:0] multiplicand;
reg [size-1:0] multiplier;
reg [2*size-1:0] accumulator;
reg [1:0] counter;

// FSM states
localparam IDLE = 0, PROCESS = 1, DONE = 2;
reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        multiplicand <= 0;
        multiplier <= 0;
        accumulator <= 0;
        counter <= 0;
        mul_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                // Initialize pipeline
                multiplicand <= {{size{1'b0}}, mul_a};
                multiplier <= mul_b;
                accumulator <= 0;
                counter <= 0;
                state <= PROCESS;
            end
            
            PROCESS: begin
                if (counter < size) begin
                    // Stage 1: Shift and prepare
                    multiplicand <= multiplicand << 1;
                    multiplier <= multiplier >> 1;
                    
                    // Stage 2: Conditional add
                    if (multiplier[0])
                        accumulator <= accumulator + multiplicand;
                    
                    counter <= counter + 1;
                end else begin
                    state <= DONE;
                end
            end
            
            DONE: begin
                // Output result
                mul_out <= accumulator;
                state <= IDLE;
            end
        endcase
    end
end

endmodule