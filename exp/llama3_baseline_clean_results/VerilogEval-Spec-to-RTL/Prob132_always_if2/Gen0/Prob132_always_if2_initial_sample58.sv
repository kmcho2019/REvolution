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
        end else begin
            shut_off_computer = 0;
        end

        if (~arrived) begin
            keep_driving = ~gas_tank_empty;
        end else begin
            keep_driving = 0; // default value when arrived is 1
        end
    end

endmodule