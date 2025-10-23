module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Unified counter running from 0 to 99 for 1MHz output timing
    reg [6:0] counter; // 7 bits to count up to 100

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            // Increment and wrap counter
            if (counter == 7'd99) begin
                counter <= 7'd0;
            end else begin
                counter <= counter + 7'd1;
            end

            // Toggle CLK_50 every 1 cycle (i.e., every clock edge)
            // Since counter increments each cycle, toggle at every count
            if (counter[0] == 1'b0) begin
                CLK_50 <= 1'b0;
            end else begin
                CLK_50 <= 1'b1;
            end
            // Alternatively, toggle CLK_50 on every clock edge (equivalent):
            // CLK_50 <= ~CLK_50;
            // but we use synchronous method here to keep single always block

            // Toggle CLK_10 every 5 cycles, so toggle on counter values 4,9,14,...
            // We'll generate a pulse for half-period (5 cycles), so toggle when (counter % 10) == 4
            if (counter % 10 == 4)
                CLK_10 <= ~CLK_10;

            // Toggle CLK_1 every 50 cycles, toggle when counter reaches 49 and 99
            if (counter == 7'd49 || counter == 7'd99)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule