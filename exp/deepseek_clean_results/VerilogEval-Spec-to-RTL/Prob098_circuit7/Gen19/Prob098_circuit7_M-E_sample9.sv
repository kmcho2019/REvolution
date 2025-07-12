module TopModule(input clk, input a, output q);
    reg q_reg;
    reg a_prev;
    reg [1:0] state;
    
    // State definitions
    localparam IDLE = 2'b00;
    localparam TOGGLE = 2'b01;
    
    // Edge detection and state machine
    always @(posedge clk) begin
        a_prev <= a;  // Store previous value for edge detection
        
        case (state)
            IDLE: begin
                if (a && !a_prev) begin  // Detect rising edge of a
                    state <= TOGGLE;
                    q_reg <= ~q_reg;
                end
            end
            TOGGLE: begin
                if (!a) begin  // Wait for a to go low before accepting new edges
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end
    
    assign q = q_reg;
endmodule