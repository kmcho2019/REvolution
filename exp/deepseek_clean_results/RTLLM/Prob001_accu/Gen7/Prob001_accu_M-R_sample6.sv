module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // State definitions
    localparam IDLE = 1'b0;
    localparam ACCUMULATE = 1'b1;
    
    reg state, next_state;
    reg [2:0] count;          // 3-bit counter (0-7)
    reg [9:0] accum_reg;      // Accumulator register
    wire [9:0] next_accum;    // Next accumulator value
    
    // Continuous assignment for adder
    assign next_accum = accum_reg + data_in;
    
    // State transition logic
    always @(*) begin
        case (state)
            IDLE: next_state = valid_in ? ACCUMULATE : IDLE;
            ACCUMULATE: begin
                if (count == 3'd3 && valid_in)
                    next_state = IDLE;
                else
                    next_state = ACCUMULATE;
            end
            default: next_state = IDLE;
        endcase
    end
    
    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 3'd0;
            accum_reg <= 10'd0;
            data_out <= 10'd0;
            valid_out <= 1'b0;
        end
        else begin
            state <= next_state;
            valid_out <= 1'b0;
            
            case (state)
                IDLE: begin
                    if (valid_in) begin
                        accum_reg <= data_in;
                        count <= 3'd1;
                    end
                end
                
                ACCUMULATE: begin
                    if (valid_in) begin
                        if (count == 3'd3) begin
                            data_out <= next_accum;
                            valid_out <= 1'b1;
                            count <= 3'd0;
                            accum_reg <= 10'd0;
                        end
                        else begin
                            accum_reg <= next_accum;
                            count <= count + 1'b1;
                        end
                    end
                end
            endcase
        end
    end

endmodule