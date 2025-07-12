module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] counter;  // 2-bit counter (0-3)
reg a_sync;         // Synchronized version of 'a'

always @(posedge clock) begin
    // Register 'a' to avoid metastability
    a_sync <= a;
    
    // p is registered version of (a at clock edge)
    p <= a_sync;
    
    // Counter logic
    if (a_sync) begin
        if (counter < 3)
            counter <= counter + 1;
    end else begin
        counter <= 0;
    end
    
    // q set logic (after 3 consecutive p=1)
    if (counter == 3)
        q <= 1;
end

// Asynchronous reset for q when a=1 during clock low
always @(negedge clock or posedge a) begin
    if (a) begin
        q <= 0;
        counter <= 0;
    end
end

endmodule