module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Shut off computer only if cpu_overheated; else zero.
    always @(*) begin
        if (cpu_overheated) begin
            shut_off_computer = 1'b1;
        end else begin
            shut_off_computer = 1'b0;
        end
    end

    // Keep driving only if not arrived and gas_tank not empty; else zero.
    always @(*) begin
        if (~arrived && ~gas_tank_empty) begin
            keep_driving = 1'b1;
        end else begin
            keep_driving = 1'b0;
        end
    end

endmodule