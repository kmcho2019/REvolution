module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg dir; // 0: incrementing, 1: decrementing
reg incr_en, decr_en;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        dir <= 0;
    end else begin
        if (dir == 0) begin
            if (counter == 31) begin
                dir <= 1;
            end else begin
                counter <= counter + 1;
            end
        end else begin
            if (counter == 0) begin
                dir <= 0;
            end else begin
                counter <= counter - 1;
            end
        end
    end
end

assign wave = counter;

// Clock gating
reg clk_en;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_en <= 0;
    end else begin
        if (dir == 0 && counter == 31) begin
            clk_en <= 1;
        end else if (dir == 1 && counter == 0) begin
            clk_en <= 1;
        end else begin
            clk_en <= 0;
        end
    end
end

// Separate enable signals for increment and decrement operations
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        incr_en <= 0;
        decr_en <= 0;
    end else begin
        if (dir == 0) begin
            incr_en <= 1;
            decr_en <= 0;
        end else begin
            incr_en <= 0;
            decr_en <= 1;
        end
    end
end

endmodule