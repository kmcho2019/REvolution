module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // State definitions
    localparam IDLE = 1'b0;
    localparam CALC = 1'b1;
    
    reg state, next_state;
    reg [3:0] count;        // 4-bit counter (0-15)
    reg [15:0] areg;        // Multiplicand register
    reg [15:0] breg;        // Multiplier register
    reg [31:0] acc;         // Accumulator
    reg [31:0] shifted_b;   // Current shifted value
    
    // State machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 4'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            acc <= 32'd0;
            shifted_b <= 32'd0;
            yout <= 32'd0;
            done <= 1'b0;
        end
        else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    count <= 4'd0;
                    acc <= 32'd0;
                    done <= 1'b0;
                    if (start) begin
                        areg <= ain;
                        breg <= bin;
                        shifted_b <= {16'd0, bin};
                    end
                end
                
                CALC: begin
                    if (areg[count]) begin
                        acc <= acc + shifted_b;
                    end
                    
                    shifted_b <= shifted_b << 1;
                    count <= count + 1;
                    
                    if (count == 4'd15) begin
                        yout <= (areg[count]) ? acc + shifted_b : acc;
                        done <= 1'b1;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = start ? CALC : IDLE;
            CALC: next_state = (count == 4'd15) ? IDLE : CALC;
            default: next_state = IDLE;
        endcase
    end

endmodule