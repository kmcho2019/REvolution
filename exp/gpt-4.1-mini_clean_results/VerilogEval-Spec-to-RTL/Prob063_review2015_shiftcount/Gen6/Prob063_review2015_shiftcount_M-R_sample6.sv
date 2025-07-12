module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    reg [3:0] next_q;

    // Initialize q to zero at simulation start for simulation stability
    // Note: This initial block does not synthesize to hardware reset!
    initial begin
        q = 4'b0000;
    end

    // Combinational logic to determine next state
    always @(*) begin
        if (shift_ena) begin
            // Shift in data at MSB, shift existing bits towards LSB
            next_q = {data, q[3:1]};
        end else if (count_ena) begin
            // Decrement with wrap-around
            next_q = q - 4'd1;
        end else begin
            // Hold current value
            next_q = q;
        end
    end

    // Sequential logic to update state on rising clock edge
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule