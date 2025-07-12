module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // One-hot state encoding
    localparam IDLE  = 5'b00001;
    localparam SETUP = 5'b00010;
    localparam CALC  = 5'b00100;
    localparam PIPE  = 5'b01000;
    localparam FINAL = 5'b10000;

    reg [4:0] state;
    reg [15:0] multiplicand;
    reg [17:0] multiplier;  // Extended with 2 guard bits
    reg [31:0] accumulator;
    reg [3:0] cycle_count;
    reg [31:0] next_accum;
    reg [15:0] shifted_operand;

    // Booth encoding outputs
    wire add, sub, shift_only;
    wire [1:0] booth_bits = multiplier[1:0];
    
    // Booth encoder
    assign add = (booth_bits == 2'b01) | (booth_bits == 2'b10);
    assign sub = (booth_bits == 2'b10);
    assign shift_only = ~(add | sub);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            yout <= 32'b0;
            done <= 1'b0;
            multiplicand <= 16'b0;
            multiplier <= 18'b0;
            accumulator <= 32'b0;
            cycle_count <= 4'b0;
            next_accum <= 32'b0;
            shifted_operand <= 16'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        state <= SETUP;
                        multiplicand <= ain;
                        multiplier <= {bin, 2'b0};  // Add guard bits
                        accumulator <= 32'b0;
                        cycle_count <= 4'b0;
                    end
                end
                
                SETUP: begin
                    // Pre-shift the multiplicand for first cycle
                    shifted_operand <= multiplicand << 1;
                    state <= CALC;
                end
                
                CALC: begin
                    // Pipelined stage - calculate next_accum in parallel
                    if (add) begin
                        next_accum <= accumulator + {shifted_operand, 1'b0};
                    end else if (sub) begin
                        next_accum <= accumulator - {shifted_operand, 1'b0};
                    end else begin
                        next_accum <= accumulator;
                    end
                    
                    state <= PIPE;
                end
                
                PIPE: begin
                    // Update accumulator with pipelined result
                    accumulator <= next_accum;
                    
                    // Shift multiplier and check for completion
                    multiplier <= multiplier >> 2;
                    shifted_operand <= shifted_operand << 2;
                    cycle_count <= cycle_count + 1;
                    
                    // Early termination if remaining bits are zero
                    if (cycle_count == 7 || multiplier[17:2] == 16'b0) begin
                        state <= FINAL;
                    end else begin
                        state <= CALC;
                    end
                end
                
                FINAL: begin
                    yout <= accumulator;
                    done <= 1'b1;
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule