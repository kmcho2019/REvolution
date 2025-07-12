module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    assign {shut_off_computer, keep_driving} = {cpu_overheated, ~gas_tank_empty & ~arrived};

endmodule