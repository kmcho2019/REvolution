module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] count; // Counter for consecutive ones
reg prev_in; // Previous input value

always @(posedge clk) begin
    if (reset) begin
        count <= 0;
        prev_in <= 0;
        disc <= 0;
        flag <= 0;
        err <= 0;
    end else begin
        prev_in <= in;
        
        if (in) begin
            count <= count + 1;
            if (count == 5) disc <= 1;
            if (count == 6 && !prev_in) flag <= 1;
            if (count >= 7) err <= 1;
        end else begin
            count <= 0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end
    end
end

endmodule