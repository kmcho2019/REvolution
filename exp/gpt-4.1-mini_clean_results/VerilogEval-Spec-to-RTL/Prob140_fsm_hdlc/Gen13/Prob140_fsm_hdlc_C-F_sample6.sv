module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd0;
            disc    <= 1'b0;
            flag    <= 1'b0;
            err     <= 1'b0;
        end else begin
            // Update counter: saturate at 7
            if (in) begin
                if (counter < 3'd7)
                    counter <= counter + 3'd1;
                else
                    counter <= 3'd7;
            end else begin
                counter <= 3'd0;
            end

            // Moore outputs asserted one cycle after detection
            disc <= (counter == 3'd5) && (in == 1'b0);
            flag <= (counter == 3'd6) && (in == 1'b0);
            err  <= (in && (counter >= 3'd6));
        end
    end

endmodule