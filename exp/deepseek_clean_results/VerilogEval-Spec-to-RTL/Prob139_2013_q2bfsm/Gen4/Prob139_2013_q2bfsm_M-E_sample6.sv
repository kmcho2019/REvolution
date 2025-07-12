module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    // State encoding with pattern progress built in
    parameter A = 3'd0;  // Reset state
    parameter B = 3'd1;  // f pulse state
    parameter C = 3'd2;  // Waiting for first 1
    parameter D = 3'd3;  // Saw 1, waiting for 0
    parameter E = 3'd4;  // Saw 1-0, waiting for 1
    parameter F = 3'd5;  // Pattern matched, monitoring y
    parameter G = 3'd6;  // Permanent g=1
    parameter H = 3'd7;  // Permanent g=0

    reg [2:0] state;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            case (state)
                A: state <= B;
                B: state <= C;
                C: state <= x ? D : C;
                D: state <= x ? D : E;
                E: state <= x ? F : C;
                F: begin
                    if (y) state <= G;
                    else state <= H;
                end
                G: state <= G;
                H: state <= H;
                default: state <= A;
            endcase
        end
    end

    // Output logic
    assign f = (state == B);
    assign g = (state == F) || (state == G);

endmodule