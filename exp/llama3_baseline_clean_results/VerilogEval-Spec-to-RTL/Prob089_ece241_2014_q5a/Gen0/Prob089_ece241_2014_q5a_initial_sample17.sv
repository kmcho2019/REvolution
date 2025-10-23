module TopModule (
    input       clk,
    input       areset,
    input       x,
    output      z
);

reg [31:0] accumulated_value;
reg [31:0] twos_complement;
reg         conversion_done;
reg         idle_state;
reg [4:0]   bit_counter;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        accumulated_value <= 0;
        twos_complement <= 0;
        conversion_done <= 0;
        idle_state <= 1;
        bit_counter <= 0;
    end else if (idle_state) begin
        if (~areset) begin
            idle_state <= 0;
            conversion_done <= 0;
            accumulated_value <= 0;
            bit_counter <= 0;
        end
    end else if (~conversion_done) begin
        if (x == 1) begin
            accumulated_value <= {accumulated_value[30:0], 1};
        end else begin
            accumulated_value <= {accumulated_value[30:0], 0};
        end
        bit_counter <= bit_counter + 1;
        if (areset) begin
            conversion_done <= 1;
            idle_state <= 1;
        end
    end
end

always @(posedge clk) begin
    if (~idle_state && ~conversion_done) begin
        if (x == 1) begin
            twos_complement[31] <= 1;
            for (int i = 0; i < 31; i++) begin
                twos_complement[i] <= ~(accumulated_value[i]);
            end
            for (int i = 0; i < 31; i++) begin
                if (twos_complement[i] == 1) begin
                    twos_complement[i] <= twos_complement[i];
                end else begin
                    twos_complement[i] <= twos_complement[i] + 1;
                end
            end
        end else begin
            twos_complement <= accumulated_value;
        end
    end
end

assign z = (idle_state || conversion_done) ? 0 : twos_complement[31 - bit_counter];

endmodule