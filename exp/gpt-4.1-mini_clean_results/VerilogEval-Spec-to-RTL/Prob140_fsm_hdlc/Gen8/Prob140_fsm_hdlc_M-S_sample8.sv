module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] count_ones, next_count_ones;

    always @(*) begin
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;
        
        if (in) begin
            if (count_ones == 3'd6)
                err = 1'b1;  // 7 or more consecutive ones -> error
            next_count_ones = (count_ones < 3'd6) ? count_ones + 1'b1 : 3'd7; 
        end else begin
            // input zero
            if (count_ones == 3'd5)
                disc = 1'b1;  // zero after five ones -> discard
            else if (count_ones == 3'd6)
                flag = 1'b1;  // zero after six ones -> flag
            next_count_ones = 3'd0;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            count_ones <= 3'd0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            count_ones <= next_count_ones;
        end
    end

endmodule