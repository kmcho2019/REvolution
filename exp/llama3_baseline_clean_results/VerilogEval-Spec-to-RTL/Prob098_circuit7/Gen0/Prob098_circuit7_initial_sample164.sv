module TopModule(
    input clk,
    input a,
    output reg q
);

reg q_init = 0; // Flag to indicate if the first transition has occurred

always @ (posedge clk) begin
    if (a == 1'b1 &&!q_init) begin // First transition of a from 0 to 1
        q <= 1'b1; // Set the output q to 1
        q_init <= 1'b1; // Set the flag to indicate that the first transition has occurred
    end else if (a == 1'b1 && q_init) begin // Subsequent transitions of a
        q <= ~q; // Toggle the output q
    end else begin // a is 0
        // Do nothing, keep the current state of q
    end
end

endmodule