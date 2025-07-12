module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // Counter of consecutive ones, saturated at 7 (3 bits)
    reg [2:0] counter, next_counter;

    // Next counter calculation (next state)
    always @(*) begin
        if (in) begin
            if (counter < 3'd7)
                next_counter = counter + 3'd1;
            else
                next_counter = 3'd7; // stay in error state
        end else begin
            next_counter = 3'd0; // reset count on zero input
        end
    end

    // Output combinational signals (Moore outputs based on current counter and input)
    wire disc_w = (counter == 3'd5) && (in == 1'b0);
    wire flag_w = (counter == 3'd6) && (in == 1'b0);
    wire err_w  = (next_counter == 3'd7);

    // Sequential logic: update counter and outputs at posedge clk with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd0;
            disc    <= 1'b0;
            flag    <= 1'b0;
            err     <= 1'b0;
        end else begin
            counter <= next_counter;
            disc    <= disc_w;
            flag    <= flag_w;
            err     <= err_w;
        end
    end

endmodule