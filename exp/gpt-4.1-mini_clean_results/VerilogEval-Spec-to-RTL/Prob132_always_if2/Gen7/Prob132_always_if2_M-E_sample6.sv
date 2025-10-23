module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        // Default assignments to prevent latches
        shut_off_computer = 1'b0;
        keep_driving      = 1'b0;

        // Set shut_off_computer if CPU overheated
        if (cpu_overheated)
            shut_off_computer = 1'b1;

        // Control keep_driving when not arrived
        if (~arrived)
            keep_driving = ~gas_tank_empty;
    end

endmodule