module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // One-hot state encoding
    localparam STATE_A = 3'b000;
    localparam STATE_B = 3'b001;
    localparam STATE_C = 3'b010;
    localparam STATE_D = 3'b100;
    
    reg [2:0] state, next_state;
    reg [2:0] r_sync;  // Synchronized input requests
    
    // Clock gating control
    wire clk_en = (state != next_state) || !resetn;
    wire gated_clk = clk & clk_en;
    
    // Input synchronization
    always @(posedge clk) begin
        if (!resetn) begin
            r_sync <= 3'b000;
        end else begin
            r_sync <= r;
        end
    end
    
    // State transition logic
    always @(*) begin
        casez (state)
            STATE_A: begin
                casez (r_sync)
                    3'b??1: next_state = STATE_B;  // r[0] has highest priority
                    3'b?10: next_state = STATE_C;
                    3'b100: next_state = STATE_D;
                    default: next_state = STATE_A;
                endcase
            end
            STATE_B: next_state = r_sync[0] ? STATE_B : STATE_A;
            STATE_C: next_state = r_sync[1] ? STATE_C : STATE_A;
            STATE_D: next_state = r_sync[2] ? STATE_D : STATE_A;
            default: next_state = STATE_A;
        endcase
    end
    
    // State register with clock gating
    always @(posedge gated_clk) begin
        if (!resetn) begin
            state <= STATE_A;
        end else begin
            state <= next_state;
        end
    end
    
    // Output register
    always @(posedge clk) begin
        if (!resetn) begin
            g <= 3'b000;
        end else begin
            case (state)
                STATE_B: g <= 3'b001;
                STATE_C: g <= 3'b010;
                STATE_D: g <= 3'b100;
                default: g <= 3'b000;
            endcase
        end
    end

endmodule