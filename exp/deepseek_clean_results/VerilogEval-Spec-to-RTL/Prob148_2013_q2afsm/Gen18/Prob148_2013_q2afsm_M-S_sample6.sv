module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // States directly represent output grants
    parameter A = 3'b000;  // Idle
    parameter B = 3'b001;  // Grant to device 0
    parameter C = 3'b010;  // Grant to device 1
    parameter D = 3'b100;  // Grant to device 2

    reg [2:0] state;

    // Output is the state itself (except idle state A)
    assign g = state;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            case (state)
                A: begin
                    if (r[0]) state <= B;
                    else if (r[1]) state <= C;
                    else if (r[2]) state <= D;
                end
                B: state <= r[0] ? B : A;
                C: state <= r[1] ? C : A;
                D: state <= r[2] ? D : A;
            endcase
        end
    end

endmodule