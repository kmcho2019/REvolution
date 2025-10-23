module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        // Default assignments to avoid latches
        shut_off_computer = 0;
        keep_driving = 0;

        // Set shut_off_computer if overheated
        if (cpu_overheated)
            shut_off_computer = 1;

        // Set keep_driving if not arrived and gas tank is not empty
        if (~arrived)
            keep_driving = ~gas_tank_empty;
    end

endmodule