module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;
    reg stage; // Pipeline stage control
    integer i;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            stage <= 1'b0; // Reset pipeline stage
        end else begin
            // Update only half the cells each cycle
            if (stage) begin
                for (i = 1; i < 512; i = i + 2) begin
                    q[i] <= next_q[i];
                end
            end else begin
                for (i = 0; i < 512; i = i + 2) begin
                    q[i] <= next_q[i];
                end
            end
            stage <= ~stage;
        end
    end

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Only compute next state for cells that will be updated next cycle
            if ((stage && (i % 2 == 1)) || (~stage && (i % 2 == 0))) begin
                reg left, center, right;
                center = q[i];
                left = (i == 511) ? 1'b0 : q[i+1];
                right = (i == 0) ? 1'b0 : q[i-1];

                case ({left, center, right})
                    3'b111: next_q[i] = 1'b0;
                    3'b110: next_q[i] = 1'b1;
                    3'b101: next_q[i] = 1'b1;
                    3'b100: next_q[i] = 1'b0;
                    3'b011: next_q[i] = 1'b1;
                    3'b010: next_q[i] = 1'b1;
                    3'b001: next_q[i] = 1'b1;
                    3'b000: next_q[i] = 1'b0;
                endcase
            end
        end
    end

endmodule