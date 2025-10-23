module TopModule (
    input        clk,
    input        load,
    input  [9:0] data,
    output       tc
);

    reg [9:0] counter;     // counts from 0 up to target
    reg [9:0] target_reg;  // holds the loaded target value

    wire eq = (counter == target_reg);

    always @(posedge clk) begin
        if (load) begin
            counter <= 10'd0;
            target_reg <= data;
        end else if (!eq) begin
            counter <= counter + 10'd1;
        end
        // else hold the count once terminal count is reached
    end

    assign tc = eq;

endmodule