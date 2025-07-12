module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [2:0] counter;
    logic running;

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            running <= 1'b1;
        end else if (running) begin
            if (counter < 4) begin
                counter <= counter + 1;
            end else begin
                running <= 1'b0;
            end
        end
    end

    assign shift_ena = (running && counter < 4) || reset;

endmodule