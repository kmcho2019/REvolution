module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // Gray-coded state encoding for minimal bit transitions
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b11;
    localparam D = 2'b10;

    reg [1:0] state;

    // State transitions with Gray coding
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            case (state)
                A: state <= in ? B : A;
                B: state <= in ? B : C;
                C: state <= in ? D : A;
                D: state <= in ? B : C;
            endcase
            
            // Registered output (Moore machine)
            out <= (state == D);
        end
    end

endmodule