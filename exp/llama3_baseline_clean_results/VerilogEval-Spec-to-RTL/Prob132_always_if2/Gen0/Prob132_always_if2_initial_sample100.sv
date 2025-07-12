module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        if (cpu_overheated) begin
            shut_off_computer = 1;
            keep_driving = 0; // When CPU is overheated, stop driving
        end else begin
            shut_off_computer = 0;
            if (~arrived)
                keep_driving = ~gas_tank_empty;
            else
                keep_driving = 0; // When arrived, stop driving
        end
    end

endmodule