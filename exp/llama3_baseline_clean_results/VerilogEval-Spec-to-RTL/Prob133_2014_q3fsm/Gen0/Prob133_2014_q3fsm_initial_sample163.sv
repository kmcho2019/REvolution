module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

reg [1:0] state; // A (2'b00), B (2'b01), count_w (2'b10)
reg [1:0] count; // counter to track the number of clock cycles
reg [1:0] w_count; // counter to track the number of times w = 1
reg z_reg; // register to hold the value of z

// initialize state to A and counters to 0
initial begin
    state = 2'b00;
    count = 2'b00;
    w_count = 2'b00;
    z_reg = 1'b0;
end

always @(posedge clk) begin
    if (reset) begin
        state = 2'b00;
        count = 2'b00;
        w_count = 2'b00;
        z_reg = 1'b0;
    end else begin
        case (state)
            2'b00: begin // state A
                if (s) begin
                    state = 2'b01;
                end
            end
            2'b01: begin // state B
                if (count == 2'b11) begin // three clock cycles passed
                    if (w_count == 2'b10) begin // w = 1 exactly twice
                        z_reg = 1'b1;
                    end else begin
                        z_reg = 1'b0;
                    end
                    count = 2'b00;
                    w_count = 2'b00;
                end else begin
                    if (w) begin
                        w_count = w_count + 1'b1;
                    end
                    count = count + 1'b1;
                end
            end
        endcase
    end
end

assign z = z_reg;

endmodule