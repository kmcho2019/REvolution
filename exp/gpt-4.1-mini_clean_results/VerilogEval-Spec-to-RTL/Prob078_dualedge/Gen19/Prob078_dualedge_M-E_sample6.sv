module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);

    reg q_master;

    // Master flip-flop: sample input d on rising edge
    always @(posedge clk) begin
        q_master <= d;
    end

    // Slave flip-flop: update output q on falling edge
    always @(negedge clk) begin
        q <= q_master;
    end

endmodule