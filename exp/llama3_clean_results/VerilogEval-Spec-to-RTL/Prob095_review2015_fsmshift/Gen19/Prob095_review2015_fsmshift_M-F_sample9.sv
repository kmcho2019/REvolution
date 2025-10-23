module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] count;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 3; // enable shift_ena for 4 cycles after reset
        end else if (count > 0) begin
            if (count > 1) begin
                count <= count - 1;
            end else begin
                count <= 0; // ensure count doesn't decrement below 0
            end
        end else begin
            count <= 0; // keep count at 0 when not in reset or counting
        end
    end

    assign shift_ena = (count > 0);

endmodule