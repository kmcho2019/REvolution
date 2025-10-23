module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        // Default assignments
        shut_off_computer = 0;
        keep_driving = 0;

        // Handle shut_off_computer output
        if (cpu_overheated) begin
            shut_off_computer = 1;
        end

        // Handle keep_driving output only if not arrived
        if (~arrived) begin
            keep_driving = ~gas_tank_empty;
        end
    end

endmodule