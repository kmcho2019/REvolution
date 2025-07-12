module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] count;
    reg [2:0] count_next;

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            count <= count_next;

            // Outputs registered from prior stable count
            disc <= (count == 3'd5) && (in == 1'b0);
            flag <= (count == 3'd6) && (in == 1'b0);
            err  <= (count >= 3'd6) && (in == 1'b1);
        end
    end

    // Next count logic separated for clarity and better timing
    always @(*) begin
        if (in) begin
            // saturate at 7
            if (count < 3'd7)
                count_next = count + 3'd1;
            else
                count_next = 3'd7;
        end else begin
            count_next = 3'd0;
        end
    end

endmodule