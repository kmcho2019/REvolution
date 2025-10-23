module TopModule(
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

    // Register control signals to align with clock domain and reduce timing path delays
    reg load_r, ena_r;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            load_r <= 1'b0;
            ena_r  <= 1'b0;
        end else begin
            load_r <= load;
            ena_r  <= ena;
        end
    end

    // Next state logic for the shift register
    reg [3:0] next_q;
    always @(*) begin
        if (load_r) begin
            next_q = data;                 // load has priority
        end else if (ena_r) begin
            next_q = {1'b0, q[3:1]};      // right shift with zero into MSB
        end else begin
            next_q = q;                   // hold state
        end
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q <= 4'b0000;
        end else begin
            q <= next_q;
        end
    end

endmodule