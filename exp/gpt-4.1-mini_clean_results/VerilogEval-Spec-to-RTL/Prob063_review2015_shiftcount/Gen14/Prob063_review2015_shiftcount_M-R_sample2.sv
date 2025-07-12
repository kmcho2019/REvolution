module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    reg initialized;
    reg [3:0] next_q;

    // Combinational logic for next_q based on control signals and current q
    always @(*) begin
        if (!initialized) begin
            next_q = 4'b0000;
        end else if (shift_ena) begin
            // Shift left with new data into LSB (MSB first in problem means data is shifted in at MSB side,
            // so data should enter at q[3], and the register shifts right)
            // Original used {q[2:0], data} shifting left by 1, placing data in LSB.
            // But problem states MSB first shifting: data shifted in at MSB, so q <= {data, q[3:1]}
            next_q = {data, q[3:1]};
        end else if (count_ena) begin
            next_q = q - 1;
        end else begin
            next_q = q; // hold current state
        end
    end

    // Sequential logic for updating q and initialized flag
    always @(posedge clk) begin
        if (!initialized) begin
            initialized <= 1'b1;
        end
        q <= next_q;
    end

endmodule