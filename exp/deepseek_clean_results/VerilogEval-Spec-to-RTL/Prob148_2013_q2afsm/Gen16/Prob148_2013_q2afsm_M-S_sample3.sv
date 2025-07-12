module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding
    localparam A = 2'b00;
    localparam B = 2'b01;  // g0 active
    localparam C = 2'b10;  // g1 active

    reg [1:0] state;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            case (state)
                A: begin
                    if (r[0]) state <= B;
                    else if (r[1]) state <= C;
                    else state <= A;
                end
                B: state <= r[0] ? B : A;
                C: state <= r[1] ? C : A;
                default: state <= A;
            endcase
        end
    end

    // Output logic
    assign g = (state == B) ? 3'b001 : 
               (state == C) ? 3'b010 : 
               3'b000;

endmodule