module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding
    localparam A = 3'b001,  // Idle state
               B = 3'b010,  // Grant to device 0
               C = 3'b100;  // Grant to device 1
    // Note: No separate state for device 2 - handled in idle state logic

    reg [2:0] state;
    wire [1:0] priority_request;

    // Priority encoder: 00=none, 01=dev0, 10=dev1, 11=dev2
    assign priority_request = r[0] ? 2'b01 : 
                             r[1] ? 2'b10 : 
                             r[2] ? 2'b11 : 2'b00;

    // State transition logic
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            case (state)
                A: begin
                    case (priority_request)
                        2'b01: state <= B;
                        2'b10: state <= C;
                        2'b11: begin
                            // Special case for device 2 - stays in A but asserts g[2]
                            state <= A;
                        end
                        default: state <= A;
                    endcase
                end
                B: state <= r[0] ? B : A;
                C: state <= r[1] ? C : A;
                // Device 2 handled in A state
                default: state <= A;
            endcase
        end
    end

    // Output logic - state bits directly drive grants
    // g[2] is special case when in state A with only r[2] asserted
    assign g[0] = (state == B);
    assign g[1] = (state == C);
    assign g[2] = (state == A) && (priority_request == 2'b11);

endmodule