module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        // Default assignments to avoid latches
        shut_off_computer = 1'b0;
        keep_driving      = 1'b0;

        // Shut down computer if CPU overheated
        if (cpu_overheated) begin
            shut_off_computer = 1'b1;
        end

        // Keep driving only if not arrived and gas tank is not empty
        if (~arrived && ~gas_tank_empty) begin
            keep_driving = 1'b1;
        end
    end

endmodule