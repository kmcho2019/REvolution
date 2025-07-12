module TopModule (
    input        cpu_overheated,
    output reg   shut_off_computer,
    input        arrived,
    input        gas_tank_empty,
    output reg   keep_driving
);

    always @(*) begin
        // Default assignments to avoid inferred latches
        shut_off_computer = 0;
        keep_driving = 0;

        // Assign shut_off_computer if cpu is overheated
        if (cpu_overheated)
            shut_off_computer = 1;

        // Assign keep_driving only if not arrived and gas tank is not empty
        if (~arrived && ~gas_tank_empty)
            keep_driving = 1;
    end

endmodule