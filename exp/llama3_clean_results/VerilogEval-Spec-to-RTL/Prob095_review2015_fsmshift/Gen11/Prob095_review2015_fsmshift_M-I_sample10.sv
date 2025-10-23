module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] count;
    logic reset_sync;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 0;
            reset_sync <= 1'b1;
        end else begin
            reset_sync <= 1'b0;
        end
    end

    always_ff @(posedge clk) begin
        if (reset_sync) begin
            shift_ena <= 1'b1;
        end else if (count < 4) begin
            count <= count + 1;
            shift_ena <= 1'b1;
        end else begin
            count <= 0;
            shift_ena <= 1'b0;
        end
    end

endmodule