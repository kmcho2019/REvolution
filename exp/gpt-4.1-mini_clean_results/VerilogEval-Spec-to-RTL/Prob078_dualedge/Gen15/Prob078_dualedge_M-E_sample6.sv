module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);

    reg master_q;

    // Master flip-flop: sample input d on positive clock edge
    always @(posedge clk) begin
        master_q <= d;
    end

    // Slave flip-flop: sample master_q on negative clock edge
    always @(negedge clk) begin
        q <= master_q;
    end

endmodule