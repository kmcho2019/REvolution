module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // State encoding (2 bits)
    localparam A = 2'b00;  // Idle
    localparam B = 2'b01;  // Grant to r0
    localparam C = 2'b10;  // Grant to r1
    localparam D = 2'b11;  // Grant to r2
    
    reg [1:0] state, next_state;
    reg [1:0] priority_ptr;  // Rotating priority pointer
    
    // State register and priority rotation
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            priority_ptr <= 2'b00;
        end else begin
            state <= next_state;
            // Rotate priority when returning to idle
            if (next_state == A && state != A)
                priority_ptr <= priority_ptr + 1;
        end
    end

    // Next state logic with dynamic priority
    always @(*) begin
        case (state)
            A: begin
                // Dynamic priority resolution
                case (priority_ptr)
                    2'b00: next_state = r[0] ? B : 
                                        r[1] ? C : 
                                        r[2] ? D : A;
                    2'b01: next_state = r[1] ? C : 
                                        r[2] ? D : 
                                        r[0] ? B : A;
                    2'b10: next_state = r[2] ? D : 
                                        r[0] ? B : 
                                        r[1] ? C : A;
                    default: next_state = A;
                endcase
            end
            B: next_state = r[0] ? B : A;
            C: next_state = r[1] ? C : A;
            D: next_state = r[2] ? D : A;
            default: next_state = A;
        endcase
    end

    // Output logic - combinational
    always @(*) begin
        g = 3'b000;
        case (state)
            B: g[0] = 1'b1;
            C: g[1] = 1'b1;
            D: g[2] = 1'b1;
            default: g = 3'b000;
        endcase
    end

endmodule