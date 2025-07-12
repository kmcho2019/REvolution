module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] counter;
reg reset_seq;

// sequential logic
always @(posedge clk) begin
    if (reset) begin
        counter = 0;
        reset_seq = 1'b1;
    end
    else if (reset_seq) begin
        if (counter == 0) begin
            counter = 4;
        end
        else if (counter > 0) begin
            counter = counter - 1;
        end
        if (counter == 0) begin
            reset_seq = 1'b0;
        end
    end
end

// continuous assignment
assign shift_ena = (counter > 0);

endmodule