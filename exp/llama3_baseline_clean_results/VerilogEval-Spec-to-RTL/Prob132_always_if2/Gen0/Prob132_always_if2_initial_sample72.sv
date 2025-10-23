module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        if (cpu_overheated)
            shut_off_computer = 1;
        else
            shut_off_computer = 0;
    end

    always @(*) begin
        if (cpu_overheated) begin
            keep_driving = 0;
        end else if (~arrived) begin
            keep_driving = ~gas_tank_empty;
        end else begin
            keep_driving = 0; // When arrived, stop driving
        end
    end

endmodule