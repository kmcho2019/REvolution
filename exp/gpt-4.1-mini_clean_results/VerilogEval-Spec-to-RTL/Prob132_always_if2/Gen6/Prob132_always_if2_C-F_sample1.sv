module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        // Explicitly assign shut_off_computer in all cases
        if (cpu_overheated)
            shut_off_computer = 1'b1;
        else
            shut_off_computer = 1'b0;

        // Explicitly assign keep_driving in all cases
        if (!arrived)
            keep_driving = ~gas_tank_empty;
        else
            keep_driving = 1'b0;
    end

endmodule