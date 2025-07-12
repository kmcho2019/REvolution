module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    // Two-stage synchronizer registers for input 'a'
    reg a_d1, a_d2;

    // Flags to indicate whether rising or falling edge was detected but not yet reported
    reg rise_pending, down_pending;

    always @(posedge clk) begin
        if (!rst_n) begin
            a_d1 <= 1'b0;
            a_d2 <= 1'b0;
            rise_pending <= 1'b0;
            down_pending <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            // Shift in current 'a' through synchronizer stages
            a_d1 <= a;
            a_d2 <= a_d1;

            // Detect edges from two synchronizer stages
            // Rising edge happened when a_d2=0 and a_d1=1
            if (~a_d2 & a_d1)
                rise_pending <= 1'b1;
            // Falling edge happened when a_d2=1 and a_d1=0
            if (a_d2 & ~a_d1)
                down_pending <= 1'b1;

            // Output pulses exactly one clock cycle when pending flags are set,
            // then clear pending flags so pulses are one-cycle
            if (rise_pending) begin
                rise <= 1'b1;
                rise_pending <= 1'b0;
            end else begin
                rise <= 1'b0;
            end

            if (down_pending) begin
                down <= 1'b1;
                down_pending <= 1'b0;
            end else begin
                down <= 1'b0;
            end
        end
    end

endmodule