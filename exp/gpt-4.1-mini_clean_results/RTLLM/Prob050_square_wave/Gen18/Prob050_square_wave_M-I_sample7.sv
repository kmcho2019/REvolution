module square_wave #(
    parameter WIDTH = 8
)(
    input  wire              clk,
    input  wire              rst_n,     // Active-low asynchronous reset
    input  wire [WIDTH-1:0]  freq,
    output reg               wave_out
);

    reg [WIDTH-1:0] count;
    wire enable_count = (freq != {WIDTH{1'b0}});

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count    <= {WIDTH{1'b0}};
            wave_out <= 1'b0;
        end else if (enable_count) begin
            if (count == (freq - 1'b1)) begin
                count    <= {WIDTH{1'b0}};
                wave_out <= ~wave_out;
            end else begin
                count <= count + 1'b1;
            end
        end else begin
            // Hold count and wave_out steady when freq is zero
            count <= {WIDTH{1'b0}};
            wave_out <= wave_out;
        end
    end

endmodule