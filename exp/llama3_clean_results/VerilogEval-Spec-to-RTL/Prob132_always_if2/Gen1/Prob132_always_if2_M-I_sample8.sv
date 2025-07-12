module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        if (cpu_overheated) begin
            if (shut_off_computer != 1) shut_off_computer = 1;
        end else begin
            if (shut_off_computer != 0) shut_off_computer = 0;
        end
    end

    always @(*) begin
        if (~arrived) begin
            if (keep_driving != ~gas_tank_empty) keep_driving = ~gas_tank_empty;
        end else begin
            if (keep_driving != 0) keep_driving = 0;
        end
    end

endmodule