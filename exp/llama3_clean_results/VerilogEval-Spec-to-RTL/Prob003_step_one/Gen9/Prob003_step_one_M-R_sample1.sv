// TopModule: A module that drives its output high.
module TopModule(
    output reg one
);
    // Use an always block to assign 1 to the output port.
    always @(*) begin
        one = 1'b1;
    end
endmodule