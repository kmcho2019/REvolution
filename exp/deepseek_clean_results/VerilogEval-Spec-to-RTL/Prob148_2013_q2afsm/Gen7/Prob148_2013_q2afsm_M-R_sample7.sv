module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // Binary encoded states
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] state;

    // State register and next state logic combined
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            case (state)
                A: state <= r[0] ? B : 
                           r[1] ? C : 
                           r[2] ? D : A;
                B: state <= r[0] ? B : A;
                C: state <= r[1] ? C : A;
                D: state <= r[2] ? D : A;
                default: state <= A;
            endcase
        end
    end

    // Output logic - explicit priority handling
    always @(*) begin
        g = 3'b000;  // Default all grants off
        case (state)
            B: g[0] = 1'b1;
            C: g[1] = 1'b1;
            D: g[2] = 1'b1;
        endcase
    end

endmodule