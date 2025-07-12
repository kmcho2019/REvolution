module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // State encoding with parameters for clarity
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    reg [1:0] state;
    reg last_in;
    wire enable = (in != last_in);  // Clock enable when input changes

    // State transition logic with clock enable
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
            out <= 0;
            last_in <= 0;
        end else if (enable) begin
            last_in <= in;
            case (state)
                A: state <= in ? B : A;
                B: state <= in ? B : C;
                C: state <= in ? D : A;
                D: state <= in ? B : C;
                default: state <= A;  // Robustness
            endcase
            
            // Registered output
            out <= (state == D);
        end
    end

endmodule