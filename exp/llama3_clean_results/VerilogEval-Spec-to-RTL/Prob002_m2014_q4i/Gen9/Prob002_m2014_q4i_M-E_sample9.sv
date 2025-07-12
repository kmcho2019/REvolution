module TopModule(
    output out
);
    always @(posedge out) begin
        out <= 1'b0;
    end

endmodule