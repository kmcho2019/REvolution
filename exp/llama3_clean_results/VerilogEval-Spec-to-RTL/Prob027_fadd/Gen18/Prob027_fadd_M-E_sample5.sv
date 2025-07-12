// Full Adder Module using Lookup Table
module TopModule #(
    parameter WIDTH = 1
)(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic [WIDTH-1:0] cin,
    output logic [WIDTH-1:0] cout,
    output logic [WIDTH-1:0] sum
);

// Internal signals to store the input values
logic [2:0] inputs;
assign inputs = {a[0], b[0], cin[0]};

// Use a case statement to generate the output values
always_comb begin
    case (inputs)
        3'b000: begin
            sum = 1'b0;
            cout = 1'b0;
        end
        3'b001: begin
            sum = 1'b1;
            cout = 1'b0;
        end
        3'b010: begin
            sum = 1'b1;
            cout = 1'b0;
        end
        3'b011: begin
            sum = 1'b0;
            cout = 1'b1;
        end
        3'b100: begin
            sum = 1'b1;
            cout = 1'b0;
        end
        3'b101: begin
            sum = 1'b0;
            cout = 1'b1;
        end
        3'b110: begin
            sum = 1'b0;
            cout = 1'b1;
        end
        3'b111: begin
            sum = 1'b1;
            cout = 1'b1;
        end
        default: begin
            sum = 1'bx;
            cout = 1'bx;
        end
    endcase
end

endmodule