module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] counter; // counts consecutive ones saturating at 7

    // Update counter with saturating increment on consecutive ones
    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd0;
        end else begin
            counter <= in ? ((counter < 3'd7) ? (counter + 3'd1) : 3'd7) : 3'd0;
        end
    end

    // Generate outputs with one cycle delay (Moore machine)
    always @(posedge clk) begin
        if (reset) begin
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            disc <= (counter == 3'd5) && (in == 1'b0);   // disc: 0111110
            flag <= (counter == 3'd6) && (in == 1'b0);   // flag: 01111110
            err  <= in && ((counter == 3'd6) || (counter == 3'd7)); // err: 7+ ones
        end
    end

endmodule