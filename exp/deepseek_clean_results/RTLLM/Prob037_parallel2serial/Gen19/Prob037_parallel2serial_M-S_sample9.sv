module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] data;     // Shift register
    reg first_cycle;    // Indicates first cycle of new data

    assign dout = data[3];
    assign valid_out = first_cycle;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data <= 0;
            first_cycle <= 1'b1;
        end else begin
            if (first_cycle) begin
                data <= d;
                first_cycle <= 1'b0;
            end else begin
                data <= {data[2:0], 1'b0};
                if (&data[2:0]) first_cycle <= 1'b1;  // Set when all shifted out
            end
        end
    end

endmodule